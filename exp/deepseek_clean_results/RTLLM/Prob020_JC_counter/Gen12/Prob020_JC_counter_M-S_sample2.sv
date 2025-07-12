module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Johnson counter: shifts right and inserts inverted LSB at MSB
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low reset
    end else begin
        Q <= {~Q[0], Q[63:1]};  // Right shift with inverted LSB
    end
end

endmodule