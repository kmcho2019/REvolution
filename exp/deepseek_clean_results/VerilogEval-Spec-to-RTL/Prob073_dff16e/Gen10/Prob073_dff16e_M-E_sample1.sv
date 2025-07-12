module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    // Parameters for configurability
    parameter BYTE_WIDTH = 8;
    parameter NUM_BYTES = 2;
    
    // Byte-wise registers
    reg [BYTE_WIDTH-1:0] byte_reg [NUM_BYTES-1:0];
    
    // Shared enable decoder
    wire [NUM_BYTES-1:0] byte_write_en;
    assign byte_write_en = {byteena[1], byteena[0]};
    
    // Byte 0 (lower byte) processing
    always @(posedge clk) begin
        if (!resetn) begin
            byte_reg[0] <= {BYTE_WIDTH{1'b0}};
        end else if (byte_write_en[0]) begin
            byte_reg[0] <= d[BYTE_WIDTH-1:0];
        end
    end
    
    // Byte 1 (upper byte) processing
    always @(posedge clk) begin
        if (!resetn) begin
            byte_reg[1] <= {BYTE_WIDTH{1'b0}};
        end else if (byte_write_en[1]) begin
            byte_reg[1] <= d[2*BYTE_WIDTH-1:BYTE_WIDTH];
        end
    end
    
    // Output assignment
    assign q = {byte_reg[1], byte_reg[0]};

endmodule