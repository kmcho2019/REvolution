module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam LOAD = 2'b01;
    localparam CALC = 2'b10;
    localparam DONE = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] count;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;
    wire acc_en;  // Accumulator enable for clock gating

    // State transition
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
            CALC: next_state = (count == 15) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Accumulator enable - only update when needed
    assign acc_en = (state == CALC) && areg[count];

    // Datapath control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    areg <= 16'b0;
                    breg <= 16'b0;
                    acc <= 32'b0;
                    count <= 4'b0;
                end
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                    acc <= 32'b0;
                    count <= 4'b0;
                end
                CALC: begin
                    if (acc_en) begin
                        acc <= acc + (breg << count);
                    end
                    count <= count + 1;
                end
                DONE: begin
                    // Single cycle state - no operation
                end
            endcase
        end
    end

    // Output assignments
    assign yout = (state == DONE) ? acc : 32'b0;
    assign done = (state == DONE);

endmodule