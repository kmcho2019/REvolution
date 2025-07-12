module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    // One-hot encoded 2-bit counter states:
    // count == 2'b000 -> no inputs accumulated
    // count == 2'b001 -> 1 input accumulated
    // count == 2'b010 -> 2 inputs accumulated
    // count == 2'b100 -> 3 inputs accumulated
    // When next input comes on count==3 (0b100), output sum and reset to 0

    reg [9:0] accumulator;
    reg [2:0] count;      // one-hot encoding for 0-3 counts

    // Initialize count to zero state (no inputs)
    localparam CNT_0 = 3'b000;
    localparam CNT_1 = 3'b001;
    localparam CNT_2 = 3'b010;
    localparam CNT_3 = 3'b100;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= CNT_0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0;

            if (valid_in) begin
                case (count)
                    CNT_0: begin
                        accumulator <= data_in; // start accumulation
                        count <= CNT_1;
                    end
                    CNT_1: begin
                        accumulator <= accumulator + data_in;
                        count <= CNT_2;
                    end
                    CNT_2: begin
                        accumulator <= accumulator + data_in;
                        count <= CNT_3;
                    end
                    CNT_3: begin
                        // On 4th input, output sum and reset
                        data_out  <= accumulator + data_in;
                        valid_out <= 1'b1;
                        accumulator <= 10'd0;
                        count <= CNT_0;
                    end
                    default: begin
                        accumulator <= 10'd0;
                        count <= CNT_0;
                    end
                endcase
            end
        end
    end

endmodule