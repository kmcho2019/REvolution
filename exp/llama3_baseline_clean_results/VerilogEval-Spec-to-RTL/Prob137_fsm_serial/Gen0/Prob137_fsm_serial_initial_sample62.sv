module TopModule (
    input  clk,
    input  reset,
    input  in,
    output done
);

// Define states
parameter IDLE = 2'b00;
parameter START_BIT = 2'b01;
parameter DATA_BITS = 2'b10;
parameter STOP_BIT = 2'b11;

// Internal signals
reg [1:0] state, next_state;
reg [7:0] data;
reg [2:0] bit_count;
reg [7:0] received_data;

// Output signal
assign done = (state == STOP_BIT && in == 1'b1);

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'b0;
        bit_count <= 3'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    state <= START_BIT;
                end else begin
                    state <= IDLE;
                end
            end
            START_BIT: begin
                state <= DATA_BITS;
            end
            DATA_BITS: begin
                if (bit_count == 3'b111) begin
                    state <= STOP_BIT;
                end else begin
                    data <= {data[6:0], in};
                    bit_count <= bit_count + 1'b1;
                end
            end
            STOP_BIT: begin
                if (in == 1'b1) begin
                    received_data <= data;
                    state <= IDLE;
                end else begin
                    state <= STOP_BIT;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule