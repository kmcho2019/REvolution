module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Internal registers
    reg [15:0] acc;
    reg [3:0] count;
    reg [7:0] shifted_A;
    reg [3:0] upper_B;
    reg state;

    // States
    localparam IDLE = 1'b0;
    localparam SERIAL = 1'b1;

    // Parallel multiply lower nibble (4 bits)
    wire [15:0] parallel_result;
    assign parallel_result = ({8'b0, A} & {16{B[0]}}) + 
                           ({7'b0, A, 1'b0} & {16{B[1]}}) +
                           ({6'b0, A, 2'b0} & {16{B[2]}}) +
                           ({5'b0, A, 3'b0} & {16{B[3]}});

    always @(*) begin
        case (state)
            IDLE: product = parallel_result;
            SERIAL: product = acc;
            default: product = 16'b0;
        endcase
    end

    // Serial processing of upper nibble
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            acc <= 16'b0;
            count <= 4'b0;
            shifted_A <= A;
            upper_B <= B[7:4];
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (|B[7:4]) begin  // If upper nibble has bits set
                        acc <= parallel_result;
                        shifted_A <= A << 4;
                        upper_B <= B[7:4];
                        count <= 4'b0;
                        state <= SERIAL;
                    end
                end
                
                SERIAL: begin
                    if (count < 4) begin
                        if (upper_B[0]) begin
                            acc <= acc + shifted_A;
                        end
                        shifted_A <= shifted_A << 1;
                        upper_B <= upper_B >> 1;
                        count <= count + 1;
                    end else begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule