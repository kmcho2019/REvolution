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
    reg [15:0] breg;
    reg [31:0] acc;
    wire [31:0] shifted_b [0:15];
    wire acc_en;

    // Pre-compute all possible shifted versions
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : shift_gen
            assign shifted_b[i] = {16'b0, breg} << i;
        end
    endgenerate

    // Clock gating for accumulator
    assign acc_en = (state == CALC) && areg[count];

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else if (next_state != state) begin // Only update if state changes
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            state[0]: next_state = start ? LOAD : IDLE;  // IDLE
            state[1]: next_state = CALC;                  // LOAD
            state[2]: next_state = (count == 15) ? DONE : CALC; // CALC
            state[3]: next_state = IDLE;                  // DONE
        endcase
    end

    // Datapath control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            count <= 4'b0;
        end else begin
            case (1'b1) // synthesis parallel_case
                state[0]: begin // IDLE
                    areg <= 16'b0;
                    breg <= 16'b0;
                    acc <= 32'b0;
                    count <= 4'b0;
                end
                state[1]: begin // LOAD
                    areg <= ain;
                    breg <= bin;
                    acc <= 32'b0;
                    count <= 4'b0;
                end
                state[2]: begin // CALC
                    if (areg[count]) begin
                        acc <= acc + shifted_b[count];
                    end
                    count <= count + 1;
                end
                state[3]: begin // DONE
                    // Maintain values
                end
            endcase
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = state[3]; // DONE state

endmodule