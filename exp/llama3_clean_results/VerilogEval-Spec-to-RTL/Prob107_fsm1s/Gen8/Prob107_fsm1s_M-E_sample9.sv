module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [0:0] count; // Using a 1-bit counter to keep track of the state

always @(posedge clk) begin
    if(reset) begin
        count <= 0; // Reset state is B, represented by count 0
    end else begin
        case(count)
            0: begin // State B
                if(~in) begin
                    count <= 1; // Transition to state A when input is 0
                end else begin
                    count <= 0; // Stay in state B when input is 1
                end
            end
            1: begin // State A
                if(~in) begin
                    count <= 0; // Transition to state B when input is 0
                end else begin
                    count <= 1; // Stay in state A when input is 1
                end
            end
        endcase
    end
end

assign out = ~count; // Output is 1 in state B (count 0) and 0 in state A (count 1)

endmodule