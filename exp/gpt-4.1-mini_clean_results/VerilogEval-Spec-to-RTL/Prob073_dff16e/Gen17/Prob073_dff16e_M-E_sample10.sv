module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input  [15:0]  d,
    output reg [15:0] q
);

wire [15:0] write_mask;
wire [15:0] next_q;

// Create a mask where each byte is either all ones or zeros based on byteena bits
assign write_mask = { {8{byteena[1]}}, {8{byteena[0]}} };

// On positive clock edge, perform synchronous active-low reset or selective byte updates
always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        // For bytes enabled by byteena, write new data; otherwise retain old data
        q <= (q & ~write_mask) | (d & write_mask);
    end
end

endmodule