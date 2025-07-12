module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        LOAD,
        CALC,
        DONE
    } state_t;

    state_t current_state, next_state;
    reg [3:0] count;  // Only needs 4 bits (0-15)
    reg [15:0] areg;
    reg [30:0] acc;   // Reduced to 31 bits (max product fits in 31 bits)
    
    // Pre-compute all shifted versions of bin
    wire [31:0] shifted_bin [0:15];
    generate
        for (genvar i = 0; i < 16; i++) begin
            assign shifted_bin[i] = bin << i;
        end
    endgenerate

    // FSM state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // FSM next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = start ? LOAD : IDLE;
            LOAD: next_state = CALC;
            CALC: next_state = (count == 15) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Datapath control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0;
            areg <= 16'b0;
            acc <= 31'b0;
        end else begin
            case (current_state)
                LOAD: begin
                    areg <= ain;
                    acc <= 31'b0;
                    count <= 4'b0;
                end
                CALC: begin
                    if (areg[count]) begin
                        acc <= acc + shifted_bin[count][30:0];
                    end
                    count <= count + 1;
                end
                DONE: begin
                    // No operation, just hold values
                end
                default: begin
                    // IDLE state - maintain values
                end
            endcase
        end
    end

    // Output assignments
    assign yout = {1'b0, acc};  // Zero-extend to 32 bits
    assign done = (current_state == DONE);

endmodule