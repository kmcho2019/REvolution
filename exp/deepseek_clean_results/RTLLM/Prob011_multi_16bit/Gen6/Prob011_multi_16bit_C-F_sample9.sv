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
    localparam IDLE = 2'b00;
    localparam LOAD = 2'b01;
    localparam CALC = 2'b10;
    localparam DONE = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] count;
    reg [15:0] areg, breg;
    reg [31:0] acc;
    reg active;

    // Clock gating control
    always @(*) begin
        active = (start || (state != IDLE));
    end

    // State machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? LOAD : IDLE;
            LOAD: next_state = CALC;
            CALC: next_state = (count == 4'd15) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Datapath (clock-gated)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            count <= 4'b0;
            done <= 1'b0;
        end else if (active) begin
            case (state)
                IDLE: begin
                    acc <= 32'b0;
                    done <= 1'b0;
                end
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                    count <= 4'b0;
                end
                CALC: begin
                    if (areg[count]) begin
                        acc <= acc + (breg << count);
                    end
                    count <= count + 1;
                end
                DONE: begin
                    yout <= acc;
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule