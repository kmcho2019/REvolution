module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0]  data_out
);

reg [1:0] state; // Finite State Machine states: 2'b00 - idle, 2'b01 - data_capture, 2'b10 - output
reg [7:0] data_first; // Register to store the first 8-bit data input

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state       <= 2'b00;
        data_first  <= 8'd0;
        valid_out   <= 1'b0;
        data_out    <= 16'd0;
    end
    else begin
        case (state)
            2'b00: begin // Idle state
                if (valid_in) begin
                    data_first  <= data_in;
                    state       <= 2'b01;
                end
            end
            2'b01: begin // Data capture state
                if (valid_in) begin
                    data_out    <= {data_first, data_in};
                    valid_out   <= 1'b1;
                    state       <= 2'b10;
                end
            end
            2'b10: begin // Output state
                valid_out   <= 1'b0;
                state       <= 2'b00;
            end
            default: begin
                state       <= 2'b00;
            end
        endcase
    end
end

endmodule