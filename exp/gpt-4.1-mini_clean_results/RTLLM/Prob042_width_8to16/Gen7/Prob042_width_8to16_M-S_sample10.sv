module width_8to16 (
    input             clk,
    input             rst_n,
    input             valid_in,
    input      [7:0]  data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;         // store first received byte
    reg       has_data_lock;     // flag indicating first byte stored
    reg [15:0] next_data_out;    // holds concatenated output for next cycle
    reg        next_valid_out;   // output valid flag for next cycle

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock       <= 8'd0;
            has_data_lock   <= 1'b0;
            next_data_out   <= 16'd0;
            next_valid_out  <= 1'b0;
            data_out        <= 16'd0;
            valid_out       <= 1'b0;
        end else begin
            // Default clear next_valid_out
            next_valid_out <= 1'b0;

            if (valid_in) begin
                if (!has_data_lock) begin
                    // Store first byte
                    data_lock     <= data_in;
                    has_data_lock <= 1'b1;
                end else begin
                    // Second byte arrived, form output for next cycle
                    next_data_out  <= {data_lock, data_in};
                    next_valid_out <= 1'b1;
                    has_data_lock  <= 1'b0; // clear lock after forming output
                end
            end

            // Update output registers with delayed output and valid
            data_out  <= next_data_out;
            valid_out <= next_valid_out;
        end
    end

endmodule