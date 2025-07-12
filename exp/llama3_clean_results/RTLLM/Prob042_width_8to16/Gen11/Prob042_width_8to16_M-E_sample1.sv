module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0]  data_out
);

reg [1:0] state;
reg [7:0] data1;
reg [7:0] data2;

// Define states
localparam IDLE = 2'b00;
localparam FIRST_VALID = 2'b01;
localparam SECOND_VALID = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state   <= IDLE;
        data1   <= 8'd0;
        data2   <= 8'd0;
        valid_out   <= 1'b0;
        data_out    <= 16'd0;
    end
    else begin
        case (state)
            IDLE: begin
                if (valid_in) begin
                    data1   <= data_in;
                    state   <= FIRST_VALID;
                end
            end
            FIRST_VALID: begin
                if (valid_in) begin
                    data2   <= data_in;
                    state   <= SECOND_VALID;
                end
            end
            SECOND_VALID: begin
                valid_out   <= 1'b1;
                data_out    <= {data1, data2};
                state   <= IDLE;
            end
            default: begin
                state   <= IDLE;
            end
        endcase
    end
end

endmodule