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
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state;
    reg [1:0] next_state;
    reg [3:0] count;
    reg [15:0] areg;
    reg [31:0] shifted_b [0:15]; // Pre-computed shifted versions
    reg [30:0] acc; // 31-bit accumulator (sufficient for max product)
    reg acc_en; // Accumulator enable for power gating

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
            IDLE: next_state = start ? CALC : IDLE;
            CALC: next_state = (count == 15) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Pre-compute all shifted versions of bin
    always @(posedge clk) begin
        if (state == IDLE && start) begin
            shifted_b[0] <= {16'b0, bin};
            for (int i=1; i<16; i=i+1) begin
                shifted_b[i] <= shifted_b[i-1] << 1;
            end
        end
    end

    // Datapath control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            acc <= 31'b0;
            count <= 4'b0;
            acc_en <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    areg <= 16'b0;
                    acc <= 31'b0;
                    count <= 4'b0;
                    acc_en <= 1'b0;
                    if (start) begin
                        areg <= ain;
                        count <= 4'b0;
                    end
                end
                CALC: begin
                    acc_en <= areg[count];
                    if (areg[count]) begin
                        acc <= acc + shifted_b[count][30:0];
                    end
                    count <= count + 1;
                end
                DONE: begin
                    // Maintain values for one cycle
                end
            endcase
        end
    end

    // Output assignments
    assign yout = {1'b0, acc}; // Zero-extend to 32 bits
    assign done = (state == DONE);

endmodule