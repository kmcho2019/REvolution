module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // Binary state encoding
    localparam IDLE = 2'b00;
    localparam LOAD = 2'b01;
    localparam CALC = 2'b10;
    localparam DONE = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] count;  // Only needs 4 bits (0-15)
    reg [15:0] areg;
    reg [31:0] breg_shift;  // Rotating shift register
    reg [31:0] acc;
    reg [31:0] acc_pipe;    // Pipeline register for accumulator
    wire clk_en;            // Clock enable for power saving

    // Clock gating for power optimization
    assign clk_en = (state != IDLE) || start || !rst_n;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            IDLE: next_state = start ? LOAD : IDLE;
            LOAD: next_state = CALC;
            CALC: next_state = (count == 15) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register (sequential with clock gating)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else if (clk_en) begin
            state <= next_state;
        end
    end

    // Datapath control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            breg_shift <= 32'b0;
            acc <= 32'b0;
            acc_pipe <= 32'b0;
            count <= 4'b0;
        end else if (clk_en) begin
            case (state)
                IDLE: begin
                    areg <= 16'b0;
                    breg_shift <= 32'b0;
                    acc <= 32'b0;
                    acc_pipe <= 32'b0;
                    count <= 4'b0;
                end
                LOAD: begin
                    areg <= ain;
                    breg_shift <= {16'b0, bin};  // Initialize shift register
                    acc <= 32'b0;
                    acc_pipe <= 32'b0;
                    count <= 4'b0;
                end
                CALC: begin
                    if (areg[count]) begin
                        acc_pipe <= acc + breg_shift;
                    end else begin
                        acc_pipe <= acc;
                    end
                    acc <= acc_pipe;  // Pipeline stage
                    breg_shift <= breg_shift << 1;  // Rotate shift register
                    count <= count + 1;
                end
                DONE: begin
                    // No operation needed
                end
            endcase
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = (state == DONE);

endmodule