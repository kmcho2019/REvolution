module accu (
    input         clk,
    input         rst_n,
    input         valid_in,
    input  [7:0]  data_in,
    output        valid_out,
    output [9:0]  data_out
);

reg [9:0] pipe_reg1;
reg [9:0] pipe_reg2;
reg [9:0] pipe_reg3;
reg [9:0] pipe_reg4;
reg [1:0] counter;
reg        valid_out_reg;

// Initialize state and signals
initial begin
    pipe_reg1 = 10'b0;
    pipe_reg2 = 10'b0;
    pipe_reg3 = 10'b0;
    pipe_reg4 = 10'b0;
    counter = 2'b0;
    valid_out_reg = 1'b0;
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        pipe_reg1 <= 10'b0;
        pipe_reg2 <= 10'b0;
        pipe_reg3 <= 10'b0;
        pipe_reg4 <= 10'b0;
        counter <= 2'b0;
        valid_out_reg <= 1'b0;
    end else begin
        if (valid_in) begin
            pipe_reg1 <= data_in;
            pipe_reg2 <= pipe_reg1 + data_in;
            pipe_reg3 <= pipe_reg2 + data_in;
            pipe_reg4 <= pipe_reg3 + data_in;
            counter <= counter + 1'b1;
            if (counter == 2'b11) begin
                valid_out_reg <= 1'b1;
                counter <= 2'b0;
            end
        end else begin
            pipe_reg1 <= 10'b0;
            pipe_reg2 <= 10'b0;
            pipe_reg3 <= 10'b0;
            pipe_reg4 <= 10'b0;
            counter <= 2'b0;
            valid_out_reg <= 1'b0;
        end
    end
end

// Output logic
assign valid_out = valid_out_reg;
assign data_out = (pipe_reg1 + pipe_reg2 + pipe_reg3 + pipe_reg4);

endmodule