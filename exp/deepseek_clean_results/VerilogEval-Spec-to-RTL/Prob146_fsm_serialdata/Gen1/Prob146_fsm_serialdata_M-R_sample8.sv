module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded states
    localparam IDLE   = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP   = 4'b0100;
    localparam ERROR  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
        end else begin
            state <= next_state;
            if (shift_enable) begin
                shift_reg <= {in, shift_reg[7:1]};  // LSB first
            end
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 0;
            end
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 0) ? RECEIVE : IDLE;
                shift_enable = 0;
            end
            RECEIVE: begin
                next_state = (bit_count == 7) ? STOP : RECEIVE;
                shift_enable = 1;
            end
            STOP: begin
                next_state = (in == 1) ? IDLE : ERROR;
                shift_enable = 0;
            end
            ERROR: begin
                next_state = (in == 1) ? IDLE : ERROR;
                shift_enable = 0;
            end
            default: begin
                next_state = IDLE;
                shift_enable = 0;
            end
        endcase
    end

    // Output logic (combinational)
    always @(*) begin
        done = (state == STOP) && (in == 1);
        if (done) begin
            out_byte = shift_reg;
        end else begin
            out_byte = 8'b0;  // Don't-care when not done
        end
    end

endmodule