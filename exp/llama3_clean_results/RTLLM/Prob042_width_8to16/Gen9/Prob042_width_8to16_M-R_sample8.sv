module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0]  data_out
);

reg [7:0] data_first; // Register to store the first 8-bit data input
reg [7:0] data_second; // Register to store the second 8-bit data input
reg [1:0] state; // Finite state machine state

localparam IDLE = 2'b00;
localparam DATA_VALID = 2'b01;
localparam OUTPUT_VALID = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_first     <= 8'd0;
        data_second    <= 8'd0;
        state          <= IDLE;
        valid_out      <= 1'b0;
        data_out       <= 16'd0;
    end
    else begin
        case (state)
            IDLE: begin
                if (valid_in) begin
                    data_first <= data_in;
                    state <= DATA_VALID;
                end
            end
            DATA_VALID: begin
                if (valid_in) begin
                    data_second <= data_in;
                    state <= OUTPUT_VALID;
                end
            end
            OUTPUT_VALID: begin
                valid_out <= 1'b1;
                data_out <= {data_first, data_second};
                state <= IDLE;
            end
        endcase
    end
end

endmodule