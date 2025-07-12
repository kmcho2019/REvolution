module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // One-hot state encoding
    localparam IDLE = 4'b0001;
    localparam LOAD = 4'b0010;
    localparam CALC = 4'b0100;
    localparam DONE = 4'b1000;

    reg [3:0] state;
    reg [3:0] next_state;
    reg [3:0] count;
    reg [15:0] areg;
    reg [31:0] acc;
    reg [15:0] shifted_bin;
    reg count_en;

    // State transition logic
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

    // Clock gating for count register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_en <= 1'b0;
        end else begin
            count_en <= (next_state == CALC);
        end
    end

    // Datapath control - pipelined implementation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            acc <= 32'b0;
            shifted_bin <= 16'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    areg <= 16'b0;
                    acc <= 32'b0;
                    shifted_bin <= 16'b0;
                    count <= 4'b0;
                end
                LOAD: begin
                    areg <= ain;
                    acc <= 32'b0;
                    shifted_bin <= bin;
                    count <= 4'b0;
                end
                CALC: begin
                    // Stage 1: Shift operation (previous cycle)
                    if (count_en) begin
                        shifted_bin <= shifted_bin << 1;
                    end

                    // Stage 2: Conditional accumulation
                    if (areg[count]) begin
                        acc <= acc + {{16{1'b0}}, shifted_bin};
                    end

                    // Update counter only when enabled
                    if (count_en) begin
                        count <= count + 1;
                    end
                end
                DONE: begin
                    // Maintain values for one cycle
                end
            endcase
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = (state == DONE);

endmodule