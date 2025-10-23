module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    reg [1:0] state; // IDLE (0), DRIVING (1), ARRIVED (2), OVERHEATED (3)
    parameter IDLE = 2'b00, DRIVING = 2'b01, ARRIVED = 2'b10, OVERHEATED = 2'b11;

    always @(*) begin
        case(state)
            IDLE: begin
                if (~cpu_overheated && ~arrived && ~gas_tank_empty) begin
                    state = DRIVING;
                    keep_driving = 1'b1;
                    shut_off_computer = 1'b0;
                end else if (cpu_overheated) begin
                    state = OVERHEATED;
                    keep_driving = 1'b0;
                    shut_off_computer = 1'b1;
                end else begin
                    state = IDLE;
                    keep_driving = 1'b0;
                    shut_off_computer = 1'b0;
                end
            end
            DRIVING: begin
                if (arrived || gas_tank_empty || cpu_overheated) begin
                    state = IDLE;
                    keep_driving = 1'b0;
                    shut_off_computer = cpu_overheated ? 1'b1 : 1'b0;
                end else begin
                    state = DRIVING;
                    keep_driving = 1'b1;
                    shut_off_computer = 1'b0;
                end
            end
            ARRIVED: begin
                if (cpu_overheated) begin
                    state = OVERHEATED;
                    keep_driving = 1'b0;
                    shut_off_computer = 1'b1;
                end else begin
                    state = ARRIVED;
                    keep_driving = 1'b0;
                    shut_off_computer = 1'b0;
                end
            end
            OVERHEATED: begin
                state = OVERHEATED;
                keep_driving = 1'b0;
                shut_off_computer = 1'b1;
            end
            default: begin
                state = IDLE;
                keep_driving = 1'b0;
                shut_off_computer = 1'b0;
            end
        endcase
    end

    initial begin
        state = IDLE;
        keep_driving = 1'b0;
        shut_off_computer = 1'b0;
    end

endmodule