module width_8to16 (
    input        clk,
    input        rst_n,
    input        valid_in,
    input  [7:0]  data_in,
    output       valid_out,
    output [15:0] data_out
);

reg [7:0] data_lock; // register to store the first valid 8-bit data input
reg        flag;    // flag signal to indicate whether the first valid data has been received
reg [15:0] data_out_reg; // internal register for data_out
reg        valid_out_reg; // internal register for valid_out

// sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // on reset, clear all registers
        data_out_reg <= 16'd0;
        valid_out_reg <= 1'b0;
        data_lock <= 8'd0;
        flag <= 1'b0;
    end else begin
        // on the positive edge of the clock signal
        if (valid_in) begin
            if (!flag) begin
                // if the flag is not active, store the first valid data in data_lock and set the flag
                data_lock <= data_in;
                flag <= 1'b1;
            end else begin
                // if the flag is active, concatenate the stored first data with the second data to form a 16-bit output data
                data_out_reg <= {data_lock, data_in};
                valid_out_reg <= 1'b1;
                flag <= 1'b0;
            end
        end else begin
            // if the input data is not valid, do not update the registers
            valid_out_reg <= 1'b0;
        end
    end
end

// combinational logic
assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule