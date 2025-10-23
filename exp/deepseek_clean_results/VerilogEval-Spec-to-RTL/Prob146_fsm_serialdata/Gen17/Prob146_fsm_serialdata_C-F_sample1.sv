module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Binary encoded FSM states
    localparam IDLE   = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP   = 2'b10;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_next;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b111;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            done <= done_next;
            
            case (state)
                IDLE: begin
                    if (!in) begin  // Start bit detected
                        state <= RECEIVE;
                        bit_count <= 3'b111;
                        shift_reg <= 8'b0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    if (bit_count == 3'b0) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count - 1;
                    end
                end
                
                STOP: begin
                    if (in) begin  // Valid stop bit
                        out_byte <= shift_reg;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    // Output and next state logic
    always @(*) begin
        done_next = 1'b0;
        
        if (state == STOP && in) begin
            done_next = 1'b1;
        end
    end

endmodule