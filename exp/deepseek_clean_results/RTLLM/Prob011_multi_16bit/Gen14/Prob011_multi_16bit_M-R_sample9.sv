module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // State definitions
    localparam IDLE   = 2'b00;
    localparam WORKING = 2'b01;
    localparam DONE   = 2'b10;

    // State registers
    reg [1:0] current_state, next_state;
    reg [4:0] bit_counter;
    reg [15:0] multiplicand;
    reg [31:0] product;

    // Combinational next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = start ? WORKING : IDLE;
            WORKING: next_state = (bit_counter == 16) ? DONE : WORKING;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Datapath control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_counter <= 5'd0;
            multiplicand <= 16'd0;
            product <= 32'd0;
            done <= 1'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    bit_counter <= 5'd0;
                    product <= 32'd0;
                    done <= 1'b0;
                    if (start) begin
                        multiplicand <= ain;
                    end
                end
                
                WORKING: begin
                    if (bit_counter < 16) begin
                        if (multiplicand[bit_counter]) begin
                            product <= product + (bin << bit_counter);
                        end
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                DONE: begin
                    yout <= product;
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule