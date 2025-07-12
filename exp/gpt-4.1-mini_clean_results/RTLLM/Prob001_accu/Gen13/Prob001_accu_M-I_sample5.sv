module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0]  data_in_reg;
    reg [9:0]  accumulator;
    reg [1:0]  count;

    // Register data_in to reduce combinational path delay
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_in_reg <= 8'd0;
        else if (valid_in)
            data_in_reg <= data_in;
    end

    wire [9:0] acc_next = accumulator + data_in_reg;

    // Update accumulator and count only when valid_in is high to save toggling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0; // Default low each cycle

            if (valid_in) begin
                if (count == 2'd3) begin
                    data_out  <= acc_next;     // Output sum of 4 inputs
                    valid_out <= 1'b1;         // One-cycle pulse
                    accumulator <= 10'd0;      // Reset accumulator
                    count <= 2'd0;             // Reset count
                end else begin
                    accumulator <= acc_next;   // Accumulate current input
                    count <= count + 1'b1;    // Increment count
                end
            end
        end
    end

endmodule