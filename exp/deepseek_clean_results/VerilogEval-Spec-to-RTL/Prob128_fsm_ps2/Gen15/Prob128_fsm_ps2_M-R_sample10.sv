module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] byte_cnt;
    
    // Continuous assignment for done signal
    assign done = (byte_cnt == 2'b10);

    always @(posedge clk) begin
        if (reset) begin
            byte_cnt <= 2'b0;
        end else begin
            case (byte_cnt)
                2'b00: byte_cnt <= in[3] ? 2'b01 : 2'b00;  // Wait for start byte
                2'b01: byte_cnt <= 2'b10;                   // Second byte
                2'b10: byte_cnt <= 2'b00;                   // Third byte, reset
                default: byte_cnt <= 2'b00;
            endcase
        end
    end

endmodule