module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state; // IDLE, START_BIT, DATA_BITS, STOP_BIT
reg [2:0] count; // Counter for data bits
reg [7:0] data; // Register to store received data byte

localparam IDLE = 3'd0;
localparam START_BIT = 3'd1;
localparam DATA_BITS = 3'd2;
localparam STOP_BIT = 3'd3;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        count <= 3'd0;
        out_byte <= 8'd0;
        done <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (!in) begin // Start bit detected
                    state <= START_BIT;
                end
            end
            START_BIT: begin
                state <= DATA_BITS;
            end
            DATA_BITS: begin
                data[count] <= in; // Store the received data bit
                if (count == 3'd7) begin // All data bits received
                    state <= STOP_BIT;
                end
                else begin
                    count <= count + 3'd1;
                end
            end
            STOP_BIT: begin
                if (in) begin // Stop bit detected
                    out_byte <= {data[6:0], data[7]}; // Least significant bit first
                    done <= 1'b1;
                    state <= IDLE;
                end
                else begin
                    state <= IDLE; // Stop bit not detected, start over
                end
            end
            default: state <= IDLE;
        endcase
    end
end

always @(posedge clk) begin
    if (state != STOP_BIT) begin
        done <= 1'b0; // De-assert done when not in STOP_BIT state
    end
end

endmodule