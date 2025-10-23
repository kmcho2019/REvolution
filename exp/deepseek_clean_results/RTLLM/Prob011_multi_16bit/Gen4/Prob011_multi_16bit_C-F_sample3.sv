module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output done
);

    // State definitions
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state, next_state;
    reg [4:0] count;        // 5-bit counter (0-16)
    reg [15:0] areg;        // Multiplicand register
    reg [15:0] breg;        // Multiplier register
    reg [31:0] yout_r;      // Accumulator
    reg [31:0] shifted_val; // Registered shifted value
    wire calc_active;

    assign calc_active = (state == CALC);
    assign done = (state == DONE);

    // State machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
            shifted_val <= 32'd0;
        end
        else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    if (start) begin
                        areg <= ain;
                        breg <= bin;
                        yout_r <= 32'd0;
                        count <= 5'd0;
                    end
                end
                
                CALC: begin
                    // Register shifted value first
                    shifted_val <= (breg << count);
                    
                    // Then accumulate if needed (pipelined)
                    if (count > 0 && areg[count-1]) begin
                        yout_r <= yout_r + shifted_val;
                    end
                    
                    count <= count + 1;
                end
                
                DONE: begin
                    // Hold values until next operation
                end
            endcase
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: next_state = start ? CALC : IDLE;
            CALC: next_state = (count == 5'd16) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output gating (reduces power when not done)
    always @(*) begin
        yout = done ? yout_r : 32'd0;
    end

endmodule