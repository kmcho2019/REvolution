module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

    reg [2:0] current_bit;

    // State update: increment or reset index
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_bit <= 3'd0;
        end else begin
            current_bit <= current_bit + 3'd1;
        end
    end

    // Output decode: one-hot output based on current_bit
    // Use a combinational always block or continuous assignment
    // continuous assignment is simpler here
    assign out = 8'b00000001 << current_bit;

endmodule