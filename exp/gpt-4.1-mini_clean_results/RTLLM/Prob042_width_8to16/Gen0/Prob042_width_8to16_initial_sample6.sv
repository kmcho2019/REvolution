module width_8to16 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_in,
    input  wire [7:0]  data_in,
    output reg         valid_out,
    output reg  [15:0] data_out
);

    reg [7:0] data_lock;
    reg       flag;

    // Internal registers for delayed output valid and data
    reg       valid_out_next;
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock      <= 8'b0;
            flag           <= 1'b0;
            valid_out      <= 1'b0;
            data_out       <= 16'b0;
            valid_out_next <= 1'b0;
            data_out_next  <= 16'b0;
        end else begin
            valid_out <= valid_out_next;
            data_out  <= data_out_next;

            if (valid_in) begin
                if (!flag) begin
                    // First valid input, store it
                    data_lock <= data_in;
                    flag      <= 1'b1;

                    // No output this cycle
                    valid_out_next <= 1'b0;
                    data_out_next  <= 16'b0;
                end else begin
                    // Second valid input, prepare output for next cycle
                    valid_out_next <= 1'b1;
                    data_out_next  <= {data_lock, data_in};
                    // Reset flag after forming output
                    flag           <= 1'b0;
                end
            end else begin
                // No new valid input, clear output valid signal
                valid_out_next <= 1'b0;
                data_out_next  <= 16'b0;
            end
        end
    end

endmodule