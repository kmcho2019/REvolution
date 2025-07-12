module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] byte_counter;

    // Counter logic
    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b0;
        end else begin
            case (byte_counter)
                2'b00: byte_counter <= (in[3]) ? 2'b01 : 2'b00;
                2'b01: byte_counter <= 2'b10;
                2'b10: byte_counter <= 2'b11;
                2'b11: byte_counter <= 2'b00;
            endcase
        end
    end

    // Done is asserted combinatorially when counter transitions to 3
    assign done = (byte_counter == 2'b11);

endmodule