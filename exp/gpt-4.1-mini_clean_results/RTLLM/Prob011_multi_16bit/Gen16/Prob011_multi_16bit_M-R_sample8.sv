module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    // State encoding
    localparam IDLE = 2'd0;
    localparam LOAD = 2'd1;
    localparam CALC = 2'd2;

    reg [1:0]    state, next_state;
    reg [4:0]    count;         // counts 0 to 16
    reg [31:0]   accumulator;   // holds accumulated partial sum
    reg [15:0]   multiplicand;
    reg [15:0]   multiplier;
    reg          done_r;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = (start) ? LOAD : IDLE;
            LOAD:   next_state = CALC;
            CALC:   next_state = (count == 5'd16) ? IDLE : CALC;
            default: next_state = IDLE;
        endcase
    end

    // State, counter, done_r sequential logic
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state       <= IDLE;
            count       <= 5'd0;
            done_r      <= 1'b0;
        end else begin
            state <= next_state;
            case(next_state)
                IDLE: begin
                    count  <= 5'd0;
                    done_r <= 1'b0;
                end
                LOAD: begin
                    count  <= 5'd0;
                    done_r <= 1'b0;
                end
                CALC: begin
                    count <= count + 5'd1;
                    done_r <= (count == 5'd15);  // done asserted on cycle after last shift-add
                end
            endcase
        end
    end

    // Multiplicand and multiplier load
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
            accumulator  <= 32'd0;
        end else begin
            case(state)
                LOAD: begin
                    multiplicand <= ain;
                    multiplier   <= bin;
                    accumulator  <= 32'd0;
                end
                CALC: begin
                    if(multiplier[0])
                        accumulator <= accumulator + {16'd0, multiplicand};
                    else
                        accumulator <= accumulator;
                    multiplier <= multiplier >> 1;
                end
                default: begin
                    multiplicand <= multiplicand;
                    multiplier   <= multiplier;
                    accumulator  <= accumulator;
                end
            endcase
        end
    end

    assign yout = accumulator;
    assign done = done_r;

endmodule