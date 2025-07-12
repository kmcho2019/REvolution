module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state, next_state;

// Define the states
localparam B = 2'b00, A = 2'b01;

// Output logic
always @(posedge clk) begin
    if(reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        B: begin
            out = 1'b1;
            if(in == 1'b0) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        A: begin
            out = 1'b0;
            if(in == 1'b0) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        default: begin
            out = 1'bx;
            next_state = B;
        end
    endcase
end

endmodule