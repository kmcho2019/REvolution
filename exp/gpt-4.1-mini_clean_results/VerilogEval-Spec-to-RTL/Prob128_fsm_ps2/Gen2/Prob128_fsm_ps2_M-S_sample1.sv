module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  in,
    output reg         done
);

    reg [1:0] byte_count; // 0: searching, 1: byte1, 2: byte2, 3: byte3 received

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'b00;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default

            case (byte_count)
                2'b00: begin
                    // Waiting for first byte with in[3] = 1
                    if (in[3]) 
                        byte_count <= 2'b01; // byte1 received
                end

                2'b01: begin
                    // byte2
                    byte_count <= 2'b10;
                end

                2'b10: begin
                    // byte3
                    byte_count <= 2'b11;
                end

                2'b11: begin
                    // Just received byte3; assert done next cycle and reset
                    done <= 1'b1;
                    byte_count <= 2'b00;
                end

                default: byte_count <= 2'b00;
            endcase
        end
    end

endmodule