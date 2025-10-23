module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] first_byte;
    reg       waiting_second;
    reg       valid_out_d;       // delayed valid signal
    reg [15:0] data_out_d;       // delayed data output

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_byte    <= 8'd0;
            waiting_second<= 1'b0;
            valid_out_d   <= 1'b0;
            data_out_d    <= 16'd0;
            valid_out     <= 1'b0;
            data_out      <= 16'd0;
        end else begin
            valid_out     <= valid_out_d;
            data_out      <= data_out_d;

            valid_out_d   <= 1'b0;  // default no output this cycle

            if (valid_in) begin
                if (!waiting_second) begin
                    // store first byte and wait for second
                    first_byte     <= data_in;
                    waiting_second <= 1'b1;
                end else begin
                    // second byte arrived, output concatenated data next cycle
                    data_out_d     <= {first_byte, data_in};
                    valid_out_d    <= 1'b1;
                    waiting_second <= 1'b0;
                end
            end
        end
    end

endmodule