module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;    // Holds first byte until second arrives
    reg       flag;         // 0: expecting first byte; 1: expecting second byte
    reg [7:0] second_byte;  // Holds second byte temporarily
    reg       valid_out_next;
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock      <= 8'd0;
            second_byte    <= 8'd0;
            flag           <= 1'b0;
            data_out       <= 16'd0;
            valid_out      <= 1'b0;
        end else begin
            data_out   <= data_out_next;
            valid_out  <= valid_out_next;

            if (valid_in) begin
                if (flag == 1'b0) begin
                    // First byte arriving, store it in data_lock
                    data_lock <= data_in;
                    // After first byte, expect second byte next
                    flag <= 1'b1;

                    // No output this cycle
                    data_out_next  <= data_out_next;
                    valid_out_next <= 1'b0;
                end else begin
                    // Second byte arriving, latch it and prepare output
                    second_byte <= data_in;
                    flag <= 1'b0; // Reset to expect first byte next time

                    // Output updated on next cycle (registered below)
                    data_out_next  <= {data_lock, data_in};
                    valid_out_next <= 1'b1;
                end
            end else begin
                // No valid input, keep outputs stable
                valid_out_next <= 1'b0;
                data_out_next  <= data_out_next;
            end
        end
    end

endmodule