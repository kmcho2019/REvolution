module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [2:0] state; // FSM state register
reg [7:0] data_first; // Register to store the first 8-bit data input
reg       valid_out_reg; // Register for valid_out
reg [15:0] data_out_reg; // Register for data_out

// Define FSM states
localparam IDLE = 3'd0;
localparam WAITING_FOR_SECOND = 3'd1;
localparam OUTPUT_DATA = 3'd2;
localparam RESET_OUTPUT = 3'd3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state          <= IDLE;
        data_first     <= 8'd0;
        valid_out_reg  <= 1'b0;
        data_out_reg   <= 16'd0;
    end
    else begin
        case (state)
            IDLE: begin
                if (valid_in) begin
                    data_first <= data_in;
                    state     <= WAITING_FOR_SECOND;
                end
            end
            WAITING_FOR_SECOND: begin
                if (valid_in) begin
                    data_out_reg  <= {data_first, data_in};
                    state        <= OUTPUT_DATA;
                end
                // If valid_in is 0, remain in WAITING_FOR_SECOND state
            end
            OUTPUT_DATA: begin
                valid_out_reg <= 1'b1;
                state        <= RESET_OUTPUT;
            end
            RESET_OUTPUT: begin
                valid_out_reg <= 1'b0;
                state        <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule