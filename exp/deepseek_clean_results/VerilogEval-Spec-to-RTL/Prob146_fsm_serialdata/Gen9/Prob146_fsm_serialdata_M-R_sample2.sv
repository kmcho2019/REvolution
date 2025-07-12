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

    reg [3:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Next state logic
    wire next_idle = (state == IDLE && in) || 
                    (state == STOP && in) || 
                    (state == ERROR && in);
    wire next_receive = (state == IDLE && !in);
    wire next_stop = (state == RECEIVE && bit_count == 3'd7);
    wire next_error = (state == STOP && !in);

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
        end else begin
            case (1'b1)  // Synthesis will optimize this case statement
                next_idle: begin
                    state <= IDLE;
                    bit_count <= 0;
                end
                next_receive: begin
                    state <= RECEIVE;
                    bit_count <= 0;
                end
                next_stop: begin
                    state <= STOP;
                end
                next_error: begin
                    state <= ERROR;
                end
                default: begin
                    if (state == RECEIVE) begin
                        bit_count <= bit_count + 1;
                    end
                end
            endcase
        end
    end

    // Shift register with enable
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 0;
        end else if (state == RECEIVE) begin
            shift_reg <= {in, shift_reg[7:1]};  // LSB first
        end
    end

    // Output logic
    always @(*) begin
        done = (state == STOP && in);
        out_byte = (state == STOP && in) ? shift_reg : 8'h00;
    end

endmodule