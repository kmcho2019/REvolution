module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [1:0] state; // FSM state register
reg [7:0] data_first; // Register to store the first 8-bit data input
reg       valid_out_reg; // Register for valid_out
reg [15:0] data_out_reg; // Register for data_out

// Define FSM states
localparam IDLE = 2'd0;
localparam WAITING_FOR_SECOND = 2'd1;
localparam OUTPUT = 2'd2;

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
                    valid_out_reg <= 1'b1;
                    state        <= OUTPUT;
                end
            end
            OUTPUT: begin
                valid_out_reg <= 1'b0;
                state        <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

assign valid_out = (state == OUTPUT) ? 1'b1 : 1'b0;
assign data_out = data_out_reg;

endmodule