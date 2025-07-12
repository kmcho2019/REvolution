module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    // Byte-wise register implementation
    reg [7:0] upper_byte;
    reg [7:0] lower_byte;

    // Shared enable decoder
    wire upper_byte_en = byteena[1];
    wire lower_byte_en = byteena[0];

    // Upper byte (d[15:8]) processing
    always @(posedge clk) begin
        if (!resetn) begin
            upper_byte <= 8'b0;
        end else if (upper_byte_en) begin
            upper_byte <= d[15:8];
        end
    end

    // Lower byte (d[7:0]) processing
    always @(posedge clk) begin
        if (!resetn) begin
            lower_byte <= 8'b0;
        end else if (lower_byte_en) begin
            lower_byte <= d[7:0];
        end
    end

    // Output assignment
    assign q = {upper_byte, lower_byte};

endmodule