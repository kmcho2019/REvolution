module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [1:0] state; // Using 2 bits to encode 2 states (0 and 1 for A and B respectively)
reg [1:0] next_state;

// State encoding
localparam A = 1'b0;
localparam B = 1'b1;

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= B;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        A: begin
            if(in == 1'b0) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if(in == 1'b0) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        default: next_state = B; // Default state in case of invalid state
    endcase
end

// Output logic based on current state
always @(*) begin
    case(state)
        A: out = 1'b0;
        B: out = 1'b1;
        default: out = 1'bx; // Unknown output for invalid state
    endcase
end

endmodule