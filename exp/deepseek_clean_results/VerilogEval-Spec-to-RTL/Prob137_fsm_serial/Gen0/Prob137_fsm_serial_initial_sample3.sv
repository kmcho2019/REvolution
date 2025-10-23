module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    // Define states
    localparam IDLE = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            
            // Count received bits in RECEIVE state
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
                data[bit_count] <= in;  // LSB first
            end else begin
                bit_count <= 3'b0;
            end
            
            // Set done when we get a valid stop bit
            done <= (state == STOP && in == 1'b1) ? 1'b1 : 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 1'b0) ? RECEIVE : IDLE;
            end
            RECEIVE: begin
                next_state = (bit_count == 3'b111) ? STOP : RECEIVE;
            end
            STOP: begin
                next_state = (in == 1'b1) ? IDLE : STOP;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule