module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_count;

// Combinational logic to determine next state
wire next_byte_count_00 = ~reset & ~in[3];
wire next_byte_count_01 = ~reset & in[3];
wire next_byte_count_10 = ~reset & byte_count == 2'b01;
wire next_byte_count_done = ~reset & byte_count == 2'b10;

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        byte_count <= 2'b00;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case ({next_byte_count_00, next_byte_count_01, next_byte_count_10})
            3'b100: begin
                byte_count <= 2'b00;
                out_bytes <= out_bytes;
                done <= 1'b0;
            end
            3'b010: begin
                byte_count <= 2'b01;
                out_bytes[23:16] <= in;
                done <= 1'b0;
            end
            3'b001: begin
                byte_count <= 2'b10;
                out_bytes[15:8] <= in;
                done <= 1'b0;
            end
            default: begin // next_byte_count_done
                byte_count <= 2'b00;
                out_bytes[7:0] <= in;
                done <= 1'b1;
            end
        endcase
    end
end

endmodule