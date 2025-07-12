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
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state, next_state;
    reg [3:0] count;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? CALC : IDLE;
            CALC: next_state = (count == 15) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

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
                    areg <= start ? ain : 16'b0;
                    breg <= start ? bin : 16'b0;
                    acc <= 32'b0;
                    count <= 4'b0;
                end
                CALC: begin
                    if (areg[count]) begin
                        acc <= acc + (breg << count);
                    end
                    count <= count + 1;
                end
                DONE: begin
                    // Maintain values
                end
            endcase
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = (state == DONE);

endmodule