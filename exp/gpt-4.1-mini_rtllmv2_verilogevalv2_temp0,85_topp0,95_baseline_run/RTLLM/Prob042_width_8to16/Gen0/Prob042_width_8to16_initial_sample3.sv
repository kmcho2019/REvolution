module width_8to16 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_in,
    input  wire [7:0]  data_in,
    output reg         valid_out,
    output reg  [15:0] data_out
);

    reg [7:0]  data_lock;
    reg        flag;           // Indicates if data_lock contains a valid first byte
    reg        valid_out_next;
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock     <= 8'd0;
            flag          <= 1'b0;
            valid_out     <= 1'b0;
            data_out      <= 16'd0;
            valid_out_next<= 1'b0;
            data_out_next <= 16'd0;
        end else begin
            // Default output valid cleared, updated later if conditions met
            valid_out <= valid_out_next;
            data_out  <= data_out_next;

            if (valid_in) begin
                if (!flag) begin
                    // Store first valid data byte
                    data_lock <= data_in;
                    flag      <= 1'b1;
                    valid_out_next <= 1'b0;
                    data_out_next  <= 16'd0;
                end else begin
                    // Second valid data input: concatenate and produce output in next cycle
                    data_out_next  <= {data_lock, data_in};
                    valid_out_next <= 1'b1;
                    flag           <= 1'b0; // Clear flag after output
                end
            end else begin
                // When no valid input, keep outputs low
                valid_out_next <= 1'b0;
                data_out_next  <= 16'd0;
            end
        end
    end

endmodule