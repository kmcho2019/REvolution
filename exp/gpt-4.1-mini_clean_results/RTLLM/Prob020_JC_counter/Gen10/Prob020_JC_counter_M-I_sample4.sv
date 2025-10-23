module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

// Parameter defining initial reset state
localparam [63:0] RESET_STATE = 64'b0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Asynchronous active-low reset
        Q <= RESET_STATE;
    end else begin
        // On each clock, shift right by one,
        // and insert the inverse of the least significant bit at MSB
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule