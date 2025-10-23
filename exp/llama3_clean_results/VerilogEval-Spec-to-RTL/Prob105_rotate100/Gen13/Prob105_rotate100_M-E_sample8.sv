module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] buffer;
reg [6:0] pointer;

// Initialize pointer
initial pointer = 0;

// Output Logic
assign q = buffer;

// Sequential Logic
always @(posedge clk) begin
    if (load) begin
        buffer <= data;
        pointer <= 0;
    end else begin
        case (ena)
            2'b01: begin
                // Right rotation
                buffer <= {buffer[0], buffer[99:1]};
                pointer <= pointer;
            end
            2'b10: begin
                // Left rotation
                buffer <= {buffer[98:0], buffer[99]};
                pointer <= pointer;
            end
            default: begin
                buffer <= buffer;
                pointer <= pointer;
            end
        endcase
    end
end

endmodule