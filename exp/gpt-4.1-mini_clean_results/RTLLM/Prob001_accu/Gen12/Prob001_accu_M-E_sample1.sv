module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] data_regs [0:3];  // Store 4 input values
    reg [1:0] count;            // Counts valid inputs received

    wire [9:0] sum_all;

    integer i;
    reg [9:0] temp_sum;

    // Combinational logic: sum four stored data and current input for final accumulation
    assign sum_all = data_regs[0] + data_regs[1] + data_regs[2] + data_regs[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count      <= 2'd0;
            valid_out  <= 1'b0;
            data_out   <= 10'd0;
            // Initialize registers to zero
            for (i = 0; i < 4; i = i +1) begin
                data_regs[i] <= 8'd0;
            end
        end else begin
            valid_out <= 1'b0; // default no pulse

            if (valid_in) begin
                if (count < 2'd3) begin
                    // Shift data in the registers to right, insert new input at position 0
                    data_regs[count] <= data_in;
                    count <= count + 1'b1;
                end else begin
                    // On the 4th valid input: store last input, sum all 4 inputs
                    data_regs[count] <= data_in;

                    // Compute sum_all + current input is not needed since data_in is stored in data_regs[3]
                    // sum_all already sums the 4 stored inputs

                    data_out <= sum_all;
                    valid_out <= 1'b1;

                    // Reset for next accumulation
                    count <= 2'd0;
                    // Optional: clear registers (not strictly necessary, but for clarity)
                    for (i = 0; i < 4; i = i +1) begin
                        data_regs[i] <= 8'd0;
                    end
                end
            end
        end
    end

endmodule