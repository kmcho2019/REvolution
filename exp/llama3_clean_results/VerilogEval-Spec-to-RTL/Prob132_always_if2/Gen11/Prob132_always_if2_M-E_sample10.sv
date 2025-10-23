module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    reg [1:0] state;

    always @(*) begin
        case (state)
            2'b00: begin // Initial state
                if (cpu_overheated) begin
                    shut_off_computer = 1'b1;
                end else begin
                    shut_off_computer = 1'b0;
                end

                if (~arrived && ~gas_tank_empty) begin
                    keep_driving = 1'b1;
                end else begin
                    keep_driving = 1'b0;
                end
            end
            2'b01: begin // cpu_overheated state
                shut_off_computer = 1'b1;
                if (~arrived && ~gas_tank_empty) begin
                    keep_driving = 1'b1;
                end else begin
                    keep_driving = 1'b0;
                end
            end
            2'b10: begin // arrived or gas_tank_empty state
                if (cpu_overheated) begin
                    shut_off_computer = 1'b1;
                end else begin
                    shut_off_computer = 1'b0;
                end
                keep_driving = 1'b0;
            end
            default: begin
                shut_off_computer = 1'b0;
                keep_driving = 1'b0;
            end
        endcase

        if (cpu_overheated) begin
            state = 2'b01;
        end else if (arrived || gas_tank_empty) begin
            state = 2'b10;
        end else begin
            state = 2'b00;
        end
    end

endmodule