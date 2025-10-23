module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] first_data;
reg [1:0] state; // 2-bit state register for FSM

localparam IDLE = 2'b00;
localparam DATA_CAPTURE = 2'b01;
localparam OUTPUT = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        case (state)
            IDLE: begin
                if (valid_in) begin
                    first_data <= data_in;
                    state <= DATA_CAPTURE;
                end
            end
            DATA_CAPTURE: begin
                if (valid_in) begin
                    data_out <= {first_data, data_in};
                    valid_out <= 1'b1;
                    state <= OUTPUT;
                end
            end
            OUTPUT: begin
                valid_out <= 1'b0; // Reset valid_out after one clock cycle
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule