module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam ACCUM_1 = 2'b01;
    localparam ACCUM_2 = 2'b10;
    localparam ACCUM_3 = 2'b11;

    reg [1:0] state;

    // Next state logic (combinational)
    wire [1:0] next_state = 
        (!valid_in) ? state :
        (state == IDLE)    ? ACCUM_1 :
        (state == ACCUM_1) ? ACCUM_2 :
        (state == ACCUM_2) ? ACCUM_3 :
                             IDLE;

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else begin
            state <= next_state;
            valid_out <= (state == ACCUM_3) & valid_in;

            if (valid_in) begin
                if (state == IDLE)
                    data_out <= data_in;
                else
                    data_out <= data_out + data_in;
            end
        end
    end

endmodule