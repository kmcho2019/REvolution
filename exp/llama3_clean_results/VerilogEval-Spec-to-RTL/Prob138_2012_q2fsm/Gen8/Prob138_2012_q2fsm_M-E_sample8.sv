module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Top-level state codes
parameter CLUSTER_ABCD = 1'b0;
parameter CLUSTER_EF = 1'b1;

// Bottom-level state codes for cluster ABCD
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Bottom-level state codes for cluster EF
parameter E = 2'b00;
parameter F = 2'b01;

// Internal state signals
reg top_level_state;
reg [1:0] bottom_level_state;

// Top-level state table
always @(*)
begin
    case(top_level_state)
        CLUSTER_ABCD: 
            case(bottom_level_state)
                A: if (w) top_level_state = CLUSTER_ABCD;
                B: if (w) top_level_state = CLUSTER_ABCD;
                C: if (w) top_level_state = CLUSTER_EF;
                D: if (w) top_level_state = CLUSTER_ABCD;
                default: top_level_state = CLUSTER_ABCD;
            endcase
        CLUSTER_EF: 
            case(bottom_level_state)
                E: if (w) top_level_state = CLUSTER_EF;
                F: if (w) top_level_state = CLUSTER_ABCD;
                default: top_level_state = CLUSTER_EF;
            endcase
        default: top_level_state = CLUSTER_ABCD;
    endcase
end

// Bottom-level state table for cluster ABCD
always @(*)
begin
    case(bottom_level_state)
        A: if (w) bottom_level_state = B; else bottom_level_state = A;
        B: if (w) bottom_level_state = C; else bottom_level_state = D;
        C: if (w) bottom_level_state = D; else bottom_level_state = D;
        D: if (w) bottom_level_state = D; else bottom_level_state = A;
        default: bottom_level_state = A;
    endcase
end

// Bottom-level state table for cluster EF
always @(*)
begin
    case(bottom_level_state)
        E: if (w) bottom_level_state = E; else bottom_level_state = D;
        F: if (w) bottom_level_state = C; else bottom_level_state = D;
        default: bottom_level_state = E;
    endcase
end

// State flip-flops
always @(posedge clk)
begin
    if(reset)
    begin
        top_level_state <= CLUSTER_ABCD;
        bottom_level_state <= A;
    end
    else
    begin
        top_level_state <= top_level_state;
        bottom_level_state <= bottom_level_state;
    end
end

// FSM output
assign z = (top_level_state == CLUSTER_EF);

endmodule