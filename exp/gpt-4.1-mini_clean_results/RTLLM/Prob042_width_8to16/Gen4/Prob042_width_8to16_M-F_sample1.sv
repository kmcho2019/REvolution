module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

// FSM states
localparam IDLE         = 1'b0;
localparam OUTPUT_READY = 1'b1;

reg        state;
reg [7:0]  first_byte;
reg        valid_out_reg;
reg [15:0] data_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state         <= IDLE;
        first_byte    <= 8'd0;
        data_out_reg  <= 16'd0;
        valid_out_reg <= 1'b0;
    end else begin
        valid_out_reg <= 1'b0; // default no valid unless set below

        case(state)
            IDLE: begin
                if (valid_in) begin
                    first_byte <= data_in;
                    state      <= OUTPUT_READY;
                end
            end
            OUTPUT_READY: begin
                if (valid_in) begin
                    data_out_reg  <= {first_byte, data_in};
                    valid_out_reg <= 1'b1;
                    state         <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

// Output registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out  <= 16'd0;
        valid_out <= 1'b0;
    end else begin
        data_out  <= data_out_reg;
        valid_out <= valid_out_reg;
    end
end

endmodule