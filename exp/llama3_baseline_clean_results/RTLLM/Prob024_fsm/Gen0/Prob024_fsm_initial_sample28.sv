module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states
parameter S0 = 4'd0,
           S1 = 4'd1,
           S2 = 4'd2,
           S3 = 4'd3,
           S4 = 4'd4,
           S5 = 4'd5;

reg [3:0] current_state;
reg [3:0] next_state;

// Initialize MATCH to 0
initial MATCH = 0;

// State register
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
        MATCH <= 0;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        S0: begin
            if (IN) begin
                next_state = S1;
                MATCH = 0;
            end else begin
                next_state = S0;
                MATCH = 0;
            end
        end
        S1: begin
            if (!IN) begin
                next_state = S2;
                MATCH = 0;
            end else begin
                next_state = S1;
                MATCH = 0;
            end
        end
        S2: begin
            if (!IN) begin
                next_state = S3;
                MATCH = 0;
            end else begin
                next_state = S1;
                MATCH = 0;
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
                MATCH = 0;
            end else begin
                next_state = S2;
                MATCH = 0;
            end
        end
        S4: begin
            if (IN) begin
                next_state = S5;
                MATCH = 1;
            end else begin
                next_state = S0;
                MATCH = 0;
            end
        end
        S5: begin
            if (IN) begin
                next_state = S5;
                MATCH = 1;
            end else begin
                next_state = S0;
                MATCH = 0;
            end
        end
        default: begin
            next_state = S0;
            MATCH = 0;
        end
    endcase
end

endmodule