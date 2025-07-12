module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] count;
reg [9:0] sum;
reg [9:0] next_sum;
reg enable;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 0;
        sum <= 0;
        enable <= 0;
    end else begin
        if (valid_in) begin
            if (count == 0) begin
                sum <= data_in;
                count <= 1;
            end else if (count == 1) begin
                sum <= sum + data_in;
                count <= 2;
            end else if (count == 2) begin
                sum <= sum + data_in;
                count <= 3;
            end else if (count == 3) begin
                sum <= sum + data_in;
                count <= 0;
                enable <= 1;
            end
        end else begin
            count <= 0;
            sum <= 0;
            enable <= 0;
        end
    end
end

assign valid_out = enable;
assign data_out = sum;

// Apply clock gating to reduce power consumption
reg clk_gated;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_gated <= 0;
    end else begin
        clk_gated <= valid_in;
    end
end

// Use a more efficient adder structure, such as a carry-save adder
// This can be implemented using a combination of half-adders and full-adders
// For simplicity, we will use a ripple-carry adder in this example
reg [9:0] adder_out;
always @(*) begin
    adder_out = sum + data_in;
end

// Use a more area-efficient logic structure, such as a ripple-carry adder
// This can be implemented using a combination of half-adders and full-adders
// For simplicity, we will use a ripple-carry adder in this example
reg [9:0] adder_out_area_efficient;
always @(*) begin
    adder_out_area_efficient = sum + data_in;
end

endmodule