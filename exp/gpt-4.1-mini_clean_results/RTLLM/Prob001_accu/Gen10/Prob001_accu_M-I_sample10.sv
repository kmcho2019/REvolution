module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0]  data_reg;
    reg [9:0]  accumulator;
    reg [1:0]  count;

    // Register data_in when valid_in is high to reduce combinational path
    always @(posedge clk) begin
        if (!rst_n)
            data_reg <= 8'd0;
        else if (valid_in)
            data_reg <= data_in;
    end

    wire [9:0] acc_next = accumulator + data_reg;

    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default to 0 each cycle

            if (valid_in) begin
                if (count == 2'd3) begin
                    data_out  <= acc_next;
                    valid_out <= 1'b1;
                    accumulator <= 10'd0;
                    count <= 2'd0;
                end else begin
                    accumulator <= acc_next;
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule