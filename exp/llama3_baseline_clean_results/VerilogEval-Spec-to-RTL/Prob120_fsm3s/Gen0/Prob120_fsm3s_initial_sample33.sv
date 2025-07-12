module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;

// Sequential Logic
always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Combinational Logic
always_comb begin
    case(current_state)
        A: begin
            if(in == 0) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            if(in == 0) begin
                next_state = C;
            end else begin
                next_state = B;
            end
        end
        C: begin
            if(in == 0) begin
                next_state = A;
            end else begin
                next_state = D;
            end
        end
        D: begin
            if(in == 0) begin
                next_state = C;
            end else begin
                next_state = B;
            end
        end
        default: next_state = A;
    endcase
end

// Output Logic
always_comb begin
    case(current_state)
        A: out = 0;
        B: out = 0;
        C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

endmodule