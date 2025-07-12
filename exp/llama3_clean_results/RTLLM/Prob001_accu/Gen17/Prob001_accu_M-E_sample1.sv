module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

// Stage 1: Data Buffering using a FIFO
reg [7:0] buffer_reg [3:0];
reg [1:0] buffer_ptr;
reg buffer_full;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        buffer_ptr <= 0;
        buffer_full <= 0;
    end else if (valid_in) begin
        if (!buffer_full) begin
            buffer_reg[buffer_ptr] <= data_in;
            if (buffer_ptr == 3) begin
                buffer_full <= 1;
                buffer_ptr <= 0;
            end else begin
                buffer_ptr <= buffer_ptr + 1;
            end
        end
    end
end

// Stage 2: Addition
reg [9:0] sum_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg <= 0;
    end else if (buffer_full) begin
        sum_reg <= buffer_reg[0] + buffer_reg[1] + buffer_reg[2] + buffer_reg[3];
    end
end

// Stage 3 & 4: Result Registration and Output
reg valid_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out_reg <= 0;
    end else if (buffer_full) begin
        valid_out_reg <= 1;
    end else begin
        valid_out_reg <= 0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum_reg;

endmodule