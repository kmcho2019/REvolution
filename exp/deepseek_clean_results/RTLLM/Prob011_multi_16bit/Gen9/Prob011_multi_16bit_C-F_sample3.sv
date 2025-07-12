module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE,
        LOAD,
        CALC,
        DONE
    } state_t;

    state_t state, next_state;
    reg [3:0] count;
    reg [15:0] areg;
    reg [31:0] accumulator;
    wire [31:0] shifted_bin [15:0];

    // Generate all possible shifted versions of bin
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : shift_gen
            assign shifted_bin[i] = bin << i;
        end
    endgenerate

    // State machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 4'd0;
            areg <= 16'd0;
            accumulator <= 32'd0;
            yout <= 32'd0;
            done <= 1'b0;
        end
        else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    count <= 4'd0;
                    accumulator <= 32'd0;
                    done <= 1'b0;
                end
                
                LOAD: begin
                    areg <= ain;
                    count <= 4'd0;
                    done <= 1'b0;
                end
                
                CALC: begin
                    if (areg[count]) begin
                        accumulator <= accumulator + shifted_bin[count];
                    end
                    count <= count + 1;
                end
                
                DONE: begin
                    yout <= accumulator;
                    done <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? LOAD : IDLE;
            LOAD: next_state = CALC;
            CALC: next_state = (count == 15) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule