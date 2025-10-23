module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    reg [1:0] byte_counter;

    // Combinational done signal
    assign done = (byte_counter == 2'b10);

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b0;
            out_bytes <= 24'b0;
        end else begin
            case (byte_counter)
                2'b00: if (in[3]) begin
                    out_bytes[23:16] <= in;
                    byte_counter <= 2'b01;
                end
                2'b01: begin
                    out_bytes[15:8] <= in;
                    byte_counter <= 2'b10;
                end
                2'b10: begin
                    out_bytes[7:0] <= in;
                    byte_counter <= 2'b00;
                end
            endcase
        end
    end

endmodule